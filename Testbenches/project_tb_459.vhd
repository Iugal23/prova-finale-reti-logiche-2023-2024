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

constant SCENARIO_LENGTH : integer := 216;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (204,0,195,0,112,0,112,0,70,0,79,0,118,0,0,0,107,0,0,0,0,0,58,0,102,0,242,0,0,0,0,0,0,0,135,0,111,0,0,0,130,0,180,0,53,0,170,0,147,0,31,0,100,0,165,0,0,0,8,0,55,0,0,0,0,0,0,0,56,0,204,0,243,0,120,0,127,0,74,0,223,0,163,0,0,0,222,0,0,0,83,0,52,0,0,0,199,0,133,0,203,0,240,0,0,0,137,0,216,0,163,0,33,0,0,0,90,0,0,0,129,0,114,0,107,0,133,0,105,0,0,0,9,0,232,0,18,0,97,0,0,0,163,0,68,0,11,0,13,0,204,0,0,0,182,0,10,0,0,0,43,0,227,0,242,0,19,0,0,0,165,0,227,0,85,0,155,0,0,0,43,0,121,0,166,0,11,0,18,0,50,0,133,0,174,0,232,0,42,0,161,0,0,0,0,0,42,0,32,0,48,0,74,0,199,0,159,0,183,0,91,0,227,0,213,0,40,0,244,0,234,0,226,0,204,0,112,0,127,0,12,0,0,0,26,0,239,0,0,0,162,0,178,0,0,0,132,0,142,0,149,0,0,0,208,0,211,0,50,0,0,0,75,0,235,0,215,0,0,0,0,0,84,0,39,0,254,0,240,0,0,0,165,0,255,0,72,0,177,0,41,0,251,0,172,0,0,0,0,0,252,0,216,0,1,0,160,0,184,0,185,0,16,0,0,0,20,0,0,0,224,0,0,0,250,0,49,0,44,0,0,0,35,0,224,0,0,0,0,0,127,0,0,0,0,0,43,0,170,0,213,0,0,0,19,0,92,0,52,0,83,0,117,0,253,0,204,0,123,0,160,0,102,0,111,0,0,0,170,0,183,0,2,0,127,0,68,0,47,0,177,0,139,0,0,0,136,0,212,0,196,0,38,0,155,0,147,0,159,0,41,0,0,0,161,0,224,0,40,0,0,0);
signal scenario_full  : scenario_type := (204,31,195,31,112,31,112,31,70,31,79,31,118,31,118,30,107,31,107,30,107,29,58,31,102,31,242,31,242,30,242,29,242,28,135,31,111,31,111,30,130,31,180,31,53,31,170,31,147,31,31,31,100,31,165,31,165,30,8,31,55,31,55,30,55,29,55,28,56,31,204,31,243,31,120,31,127,31,74,31,223,31,163,31,163,30,222,31,222,30,83,31,52,31,52,30,199,31,133,31,203,31,240,31,240,30,137,31,216,31,163,31,33,31,33,30,90,31,90,30,129,31,114,31,107,31,133,31,105,31,105,30,9,31,232,31,18,31,97,31,97,30,163,31,68,31,11,31,13,31,204,31,204,30,182,31,10,31,10,30,43,31,227,31,242,31,19,31,19,30,165,31,227,31,85,31,155,31,155,30,43,31,121,31,166,31,11,31,18,31,50,31,133,31,174,31,232,31,42,31,161,31,161,30,161,29,42,31,32,31,48,31,74,31,199,31,159,31,183,31,91,31,227,31,213,31,40,31,244,31,234,31,226,31,204,31,112,31,127,31,12,31,12,30,26,31,239,31,239,30,162,31,178,31,178,30,132,31,142,31,149,31,149,30,208,31,211,31,50,31,50,30,75,31,235,31,215,31,215,30,215,29,84,31,39,31,254,31,240,31,240,30,165,31,255,31,72,31,177,31,41,31,251,31,172,31,172,30,172,29,252,31,216,31,1,31,160,31,184,31,185,31,16,31,16,30,20,31,20,30,224,31,224,30,250,31,49,31,44,31,44,30,35,31,224,31,224,30,224,29,127,31,127,30,127,29,43,31,170,31,213,31,213,30,19,31,92,31,52,31,83,31,117,31,253,31,204,31,123,31,160,31,102,31,111,31,111,30,170,31,183,31,2,31,127,31,68,31,47,31,177,31,139,31,139,30,136,31,212,31,196,31,38,31,155,31,147,31,159,31,41,31,41,30,161,31,224,31,40,31,40,30);

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
