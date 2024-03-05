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

constant SCENARIO_LENGTH : integer := 319;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (57,0,236,0,242,0,127,0,203,0,164,0,218,0,151,0,0,0,171,0,254,0,0,0,158,0,141,0,105,0,80,0,83,0,0,0,0,0,36,0,230,0,47,0,150,0,23,0,0,0,236,0,60,0,0,0,213,0,140,0,249,0,146,0,113,0,0,0,0,0,206,0,224,0,0,0,145,0,3,0,0,0,235,0,137,0,171,0,199,0,105,0,165,0,140,0,94,0,149,0,15,0,34,0,52,0,213,0,97,0,239,0,138,0,0,0,188,0,150,0,64,0,133,0,50,0,190,0,129,0,0,0,0,0,226,0,0,0,181,0,14,0,1,0,239,0,89,0,74,0,184,0,178,0,95,0,0,0,37,0,163,0,0,0,59,0,8,0,88,0,122,0,0,0,0,0,42,0,173,0,64,0,26,0,248,0,83,0,96,0,56,0,0,0,33,0,202,0,244,0,83,0,234,0,23,0,177,0,0,0,192,0,173,0,80,0,247,0,135,0,100,0,10,0,0,0,45,0,30,0,123,0,0,0,0,0,224,0,154,0,64,0,2,0,80,0,0,0,168,0,116,0,175,0,0,0,101,0,170,0,250,0,10,0,148,0,19,0,216,0,0,0,0,0,214,0,93,0,180,0,0,0,0,0,136,0,204,0,0,0,10,0,223,0,110,0,221,0,25,0,0,0,74,0,21,0,129,0,18,0,33,0,174,0,120,0,48,0,123,0,207,0,102,0,67,0,245,0,255,0,29,0,0,0,233,0,193,0,0,0,84,0,169,0,16,0,232,0,164,0,121,0,23,0,0,0,139,0,28,0,186,0,120,0,89,0,194,0,113,0,219,0,211,0,0,0,84,0,0,0,0,0,157,0,10,0,112,0,150,0,0,0,43,0,16,0,38,0,242,0,210,0,0,0,79,0,231,0,111,0,221,0,126,0,0,0,63,0,0,0,0,0,117,0,163,0,73,0,42,0,171,0,211,0,196,0,52,0,158,0,0,0,31,0,186,0,36,0,71,0,110,0,51,0,241,0,67,0,45,0,0,0,0,0,244,0,0,0,220,0,149,0,92,0,149,0,85,0,0,0,163,0,0,0,43,0,122,0,147,0,166,0,2,0,49,0,89,0,78,0,92,0,0,0,247,0,204,0,79,0,211,0,36,0,130,0,179,0,229,0,0,0,0,0,200,0,229,0,182,0,0,0,208,0,41,0,247,0,241,0,99,0,0,0,203,0,181,0,180,0,142,0,108,0,239,0,190,0,242,0,0,0,216,0,74,0,169,0,74,0,202,0,243,0,122,0,37,0,10,0,0,0,0,0,90,0,35,0,141,0,91,0,21,0,190,0,154,0,172,0,18,0,171,0,149,0,115,0,171,0,124,0,207,0,250,0,0,0,236,0,0,0,116,0,239,0,237,0,43,0,0,0,0,0,0,0,0,0);
signal scenario_full  : scenario_type := (57,31,236,31,242,31,127,31,203,31,164,31,218,31,151,31,151,30,171,31,254,31,254,30,158,31,141,31,105,31,80,31,83,31,83,30,83,29,36,31,230,31,47,31,150,31,23,31,23,30,236,31,60,31,60,30,213,31,140,31,249,31,146,31,113,31,113,30,113,29,206,31,224,31,224,30,145,31,3,31,3,30,235,31,137,31,171,31,199,31,105,31,165,31,140,31,94,31,149,31,15,31,34,31,52,31,213,31,97,31,239,31,138,31,138,30,188,31,150,31,64,31,133,31,50,31,190,31,129,31,129,30,129,29,226,31,226,30,181,31,14,31,1,31,239,31,89,31,74,31,184,31,178,31,95,31,95,30,37,31,163,31,163,30,59,31,8,31,88,31,122,31,122,30,122,29,42,31,173,31,64,31,26,31,248,31,83,31,96,31,56,31,56,30,33,31,202,31,244,31,83,31,234,31,23,31,177,31,177,30,192,31,173,31,80,31,247,31,135,31,100,31,10,31,10,30,45,31,30,31,123,31,123,30,123,29,224,31,154,31,64,31,2,31,80,31,80,30,168,31,116,31,175,31,175,30,101,31,170,31,250,31,10,31,148,31,19,31,216,31,216,30,216,29,214,31,93,31,180,31,180,30,180,29,136,31,204,31,204,30,10,31,223,31,110,31,221,31,25,31,25,30,74,31,21,31,129,31,18,31,33,31,174,31,120,31,48,31,123,31,207,31,102,31,67,31,245,31,255,31,29,31,29,30,233,31,193,31,193,30,84,31,169,31,16,31,232,31,164,31,121,31,23,31,23,30,139,31,28,31,186,31,120,31,89,31,194,31,113,31,219,31,211,31,211,30,84,31,84,30,84,29,157,31,10,31,112,31,150,31,150,30,43,31,16,31,38,31,242,31,210,31,210,30,79,31,231,31,111,31,221,31,126,31,126,30,63,31,63,30,63,29,117,31,163,31,73,31,42,31,171,31,211,31,196,31,52,31,158,31,158,30,31,31,186,31,36,31,71,31,110,31,51,31,241,31,67,31,45,31,45,30,45,29,244,31,244,30,220,31,149,31,92,31,149,31,85,31,85,30,163,31,163,30,43,31,122,31,147,31,166,31,2,31,49,31,89,31,78,31,92,31,92,30,247,31,204,31,79,31,211,31,36,31,130,31,179,31,229,31,229,30,229,29,200,31,229,31,182,31,182,30,208,31,41,31,247,31,241,31,99,31,99,30,203,31,181,31,180,31,142,31,108,31,239,31,190,31,242,31,242,30,216,31,74,31,169,31,74,31,202,31,243,31,122,31,37,31,10,31,10,30,10,29,90,31,35,31,141,31,91,31,21,31,190,31,154,31,172,31,18,31,171,31,149,31,115,31,171,31,124,31,207,31,250,31,250,30,236,31,236,30,116,31,239,31,237,31,43,31,43,30,43,29,43,28,43,27);

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
