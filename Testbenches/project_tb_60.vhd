-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 299;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,189,0,245,0,42,0,13,0,209,0,0,0,0,0,124,0,166,0,204,0,0,0,201,0,129,0,0,0,70,0,237,0,0,0,185,0,206,0,98,0,55,0,130,0,194,0,116,0,30,0,108,0,87,0,21,0,116,0,207,0,132,0,0,0,75,0,99,0,110,0,0,0,154,0,157,0,91,0,205,0,217,0,15,0,2,0,0,0,42,0,115,0,185,0,215,0,110,0,0,0,0,0,146,0,171,0,0,0,168,0,91,0,0,0,93,0,250,0,206,0,239,0,0,0,216,0,0,0,103,0,139,0,220,0,55,0,180,0,157,0,0,0,182,0,241,0,18,0,0,0,4,0,50,0,107,0,193,0,7,0,205,0,59,0,154,0,247,0,141,0,133,0,154,0,89,0,0,0,176,0,0,0,39,0,199,0,0,0,9,0,18,0,245,0,16,0,193,0,90,0,0,0,50,0,115,0,0,0,75,0,36,0,82,0,132,0,17,0,47,0,116,0,93,0,0,0,0,0,213,0,172,0,251,0,234,0,0,0,189,0,37,0,202,0,236,0,17,0,254,0,201,0,242,0,0,0,169,0,52,0,123,0,165,0,0,0,0,0,99,0,9,0,0,0,127,0,4,0,254,0,0,0,124,0,184,0,30,0,136,0,55,0,66,0,0,0,38,0,0,0,0,0,1,0,66,0,100,0,1,0,23,0,11,0,194,0,117,0,0,0,185,0,37,0,231,0,103,0,146,0,60,0,196,0,184,0,216,0,0,0,123,0,233,0,0,0,0,0,0,0,130,0,38,0,30,0,137,0,250,0,26,0,199,0,51,0,103,0,44,0,167,0,216,0,116,0,86,0,0,0,250,0,0,0,42,0,248,0,227,0,115,0,210,0,220,0,0,0,31,0,202,0,132,0,123,0,15,0,216,0,41,0,202,0,0,0,0,0,65,0,0,0,93,0,120,0,115,0,117,0,83,0,81,0,161,0,7,0,242,0,0,0,0,0,168,0,0,0,51,0,140,0,28,0,82,0,180,0,199,0,0,0,173,0,217,0,0,0,0,0,63,0,250,0,14,0,193,0,170,0,165,0,239,0,0,0,219,0,164,0,237,0,89,0,55,0,190,0,251,0,18,0,204,0,236,0,0,0,125,0,0,0,0,0,6,0,0,0,40,0,194,0,0,0,174,0,0,0,181,0,236,0,68,0,227,0,163,0,0,0,19,0,186,0,0,0,126,0,170,0,213,0,62,0,253,0,3,0,176,0,140,0,7,0,102,0,154,0,189,0,17,0,16,0,176,0,25,0,214,0,0,0,94,0,249,0,3,0,160,0,0,0,157,0,0,0);
signal scenario_full  : scenario_type := (0,0,189,31,245,31,42,31,13,31,209,31,209,30,209,29,124,31,166,31,204,31,204,30,201,31,129,31,129,30,70,31,237,31,237,30,185,31,206,31,98,31,55,31,130,31,194,31,116,31,30,31,108,31,87,31,21,31,116,31,207,31,132,31,132,30,75,31,99,31,110,31,110,30,154,31,157,31,91,31,205,31,217,31,15,31,2,31,2,30,42,31,115,31,185,31,215,31,110,31,110,30,110,29,146,31,171,31,171,30,168,31,91,31,91,30,93,31,250,31,206,31,239,31,239,30,216,31,216,30,103,31,139,31,220,31,55,31,180,31,157,31,157,30,182,31,241,31,18,31,18,30,4,31,50,31,107,31,193,31,7,31,205,31,59,31,154,31,247,31,141,31,133,31,154,31,89,31,89,30,176,31,176,30,39,31,199,31,199,30,9,31,18,31,245,31,16,31,193,31,90,31,90,30,50,31,115,31,115,30,75,31,36,31,82,31,132,31,17,31,47,31,116,31,93,31,93,30,93,29,213,31,172,31,251,31,234,31,234,30,189,31,37,31,202,31,236,31,17,31,254,31,201,31,242,31,242,30,169,31,52,31,123,31,165,31,165,30,165,29,99,31,9,31,9,30,127,31,4,31,254,31,254,30,124,31,184,31,30,31,136,31,55,31,66,31,66,30,38,31,38,30,38,29,1,31,66,31,100,31,1,31,23,31,11,31,194,31,117,31,117,30,185,31,37,31,231,31,103,31,146,31,60,31,196,31,184,31,216,31,216,30,123,31,233,31,233,30,233,29,233,28,130,31,38,31,30,31,137,31,250,31,26,31,199,31,51,31,103,31,44,31,167,31,216,31,116,31,86,31,86,30,250,31,250,30,42,31,248,31,227,31,115,31,210,31,220,31,220,30,31,31,202,31,132,31,123,31,15,31,216,31,41,31,202,31,202,30,202,29,65,31,65,30,93,31,120,31,115,31,117,31,83,31,81,31,161,31,7,31,242,31,242,30,242,29,168,31,168,30,51,31,140,31,28,31,82,31,180,31,199,31,199,30,173,31,217,31,217,30,217,29,63,31,250,31,14,31,193,31,170,31,165,31,239,31,239,30,219,31,164,31,237,31,89,31,55,31,190,31,251,31,18,31,204,31,236,31,236,30,125,31,125,30,125,29,6,31,6,30,40,31,194,31,194,30,174,31,174,30,181,31,236,31,68,31,227,31,163,31,163,30,19,31,186,31,186,30,126,31,170,31,213,31,62,31,253,31,3,31,176,31,140,31,7,31,102,31,154,31,189,31,17,31,16,31,176,31,25,31,214,31,214,30,94,31,249,31,3,31,160,31,160,30,157,31,157,30);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
