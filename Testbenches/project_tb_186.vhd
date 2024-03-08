-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_186 is
end project_tb_186;

architecture project_tb_arch_186 of project_tb_186 is
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

constant SCENARIO_LENGTH : integer := 350;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (216,0,162,0,44,0,105,0,87,0,157,0,106,0,167,0,173,0,121,0,255,0,125,0,15,0,111,0,0,0,139,0,13,0,112,0,248,0,207,0,0,0,239,0,0,0,247,0,89,0,125,0,239,0,188,0,0,0,230,0,26,0,39,0,181,0,210,0,143,0,219,0,142,0,47,0,190,0,0,0,199,0,57,0,241,0,0,0,205,0,153,0,254,0,99,0,186,0,70,0,0,0,211,0,32,0,0,0,170,0,0,0,146,0,0,0,59,0,224,0,31,0,173,0,62,0,0,0,97,0,244,0,70,0,102,0,0,0,157,0,0,0,224,0,45,0,0,0,147,0,150,0,196,0,0,0,0,0,237,0,44,0,51,0,42,0,118,0,198,0,166,0,206,0,101,0,70,0,33,0,137,0,0,0,250,0,0,0,0,0,25,0,216,0,0,0,0,0,0,0,145,0,0,0,254,0,54,0,103,0,3,0,173,0,0,0,0,0,0,0,212,0,236,0,154,0,72,0,128,0,0,0,43,0,100,0,105,0,0,0,0,0,104,0,152,0,110,0,0,0,136,0,190,0,137,0,0,0,190,0,49,0,200,0,0,0,30,0,182,0,42,0,168,0,251,0,0,0,87,0,187,0,197,0,39,0,57,0,230,0,201,0,173,0,41,0,44,0,175,0,180,0,49,0,120,0,117,0,231,0,197,0,35,0,172,0,156,0,112,0,252,0,98,0,6,0,189,0,0,0,164,0,0,0,199,0,213,0,0,0,176,0,62,0,171,0,60,0,151,0,96,0,193,0,61,0,63,0,0,0,32,0,214,0,0,0,203,0,27,0,239,0,0,0,110,0,134,0,34,0,12,0,0,0,13,0,18,0,185,0,0,0,75,0,196,0,194,0,30,0,233,0,100,0,121,0,193,0,6,0,201,0,23,0,0,0,250,0,220,0,0,0,205,0,56,0,0,0,97,0,0,0,104,0,0,0,0,0,153,0,0,0,198,0,233,0,203,0,44,0,0,0,0,0,191,0,205,0,126,0,0,0,196,0,58,0,198,0,194,0,0,0,79,0,91,0,0,0,59,0,107,0,0,0,0,0,104,0,0,0,167,0,104,0,99,0,0,0,0,0,18,0,2,0,6,0,222,0,164,0,238,0,133,0,25,0,242,0,140,0,155,0,2,0,238,0,167,0,222,0,123,0,120,0,66,0,0,0,0,0,11,0,69,0,40,0,102,0,128,0,0,0,119,0,0,0,90,0,46,0,211,0,0,0,88,0,0,0,0,0,164,0,0,0,246,0,204,0,77,0,50,0,162,0,0,0,0,0,6,0,127,0,65,0,218,0,0,0,134,0,25,0,0,0,0,0,251,0,202,0,162,0,149,0,88,0,106,0,78,0,160,0,110,0,0,0,51,0,227,0,247,0,112,0,249,0,146,0,164,0,133,0,94,0,41,0,23,0,216,0,254,0,0,0,0,0,0,0,240,0,13,0,167,0,0,0,25,0,164,0,0,0,245,0,79,0,202,0,130,0,52,0,85,0,156,0,71,0,221,0,148,0,0,0,165,0,27,0,176,0);
signal scenario_full  : scenario_type := (216,31,162,31,44,31,105,31,87,31,157,31,106,31,167,31,173,31,121,31,255,31,125,31,15,31,111,31,111,30,139,31,13,31,112,31,248,31,207,31,207,30,239,31,239,30,247,31,89,31,125,31,239,31,188,31,188,30,230,31,26,31,39,31,181,31,210,31,143,31,219,31,142,31,47,31,190,31,190,30,199,31,57,31,241,31,241,30,205,31,153,31,254,31,99,31,186,31,70,31,70,30,211,31,32,31,32,30,170,31,170,30,146,31,146,30,59,31,224,31,31,31,173,31,62,31,62,30,97,31,244,31,70,31,102,31,102,30,157,31,157,30,224,31,45,31,45,30,147,31,150,31,196,31,196,30,196,29,237,31,44,31,51,31,42,31,118,31,198,31,166,31,206,31,101,31,70,31,33,31,137,31,137,30,250,31,250,30,250,29,25,31,216,31,216,30,216,29,216,28,145,31,145,30,254,31,54,31,103,31,3,31,173,31,173,30,173,29,173,28,212,31,236,31,154,31,72,31,128,31,128,30,43,31,100,31,105,31,105,30,105,29,104,31,152,31,110,31,110,30,136,31,190,31,137,31,137,30,190,31,49,31,200,31,200,30,30,31,182,31,42,31,168,31,251,31,251,30,87,31,187,31,197,31,39,31,57,31,230,31,201,31,173,31,41,31,44,31,175,31,180,31,49,31,120,31,117,31,231,31,197,31,35,31,172,31,156,31,112,31,252,31,98,31,6,31,189,31,189,30,164,31,164,30,199,31,213,31,213,30,176,31,62,31,171,31,60,31,151,31,96,31,193,31,61,31,63,31,63,30,32,31,214,31,214,30,203,31,27,31,239,31,239,30,110,31,134,31,34,31,12,31,12,30,13,31,18,31,185,31,185,30,75,31,196,31,194,31,30,31,233,31,100,31,121,31,193,31,6,31,201,31,23,31,23,30,250,31,220,31,220,30,205,31,56,31,56,30,97,31,97,30,104,31,104,30,104,29,153,31,153,30,198,31,233,31,203,31,44,31,44,30,44,29,191,31,205,31,126,31,126,30,196,31,58,31,198,31,194,31,194,30,79,31,91,31,91,30,59,31,107,31,107,30,107,29,104,31,104,30,167,31,104,31,99,31,99,30,99,29,18,31,2,31,6,31,222,31,164,31,238,31,133,31,25,31,242,31,140,31,155,31,2,31,238,31,167,31,222,31,123,31,120,31,66,31,66,30,66,29,11,31,69,31,40,31,102,31,128,31,128,30,119,31,119,30,90,31,46,31,211,31,211,30,88,31,88,30,88,29,164,31,164,30,246,31,204,31,77,31,50,31,162,31,162,30,162,29,6,31,127,31,65,31,218,31,218,30,134,31,25,31,25,30,25,29,251,31,202,31,162,31,149,31,88,31,106,31,78,31,160,31,110,31,110,30,51,31,227,31,247,31,112,31,249,31,146,31,164,31,133,31,94,31,41,31,23,31,216,31,254,31,254,30,254,29,254,28,240,31,13,31,167,31,167,30,25,31,164,31,164,30,245,31,79,31,202,31,130,31,52,31,85,31,156,31,71,31,221,31,148,31,148,30,165,31,27,31,176,31);

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
