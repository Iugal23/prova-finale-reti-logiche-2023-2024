-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_555 is
end project_tb_555;

architecture project_tb_arch_555 of project_tb_555 is
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

constant SCENARIO_LENGTH : integer := 214;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (243,0,165,0,218,0,146,0,0,0,218,0,0,0,135,0,173,0,51,0,121,0,48,0,146,0,181,0,0,0,0,0,0,0,169,0,188,0,184,0,0,0,0,0,17,0,54,0,148,0,150,0,233,0,97,0,113,0,150,0,131,0,159,0,0,0,144,0,68,0,140,0,104,0,191,0,206,0,112,0,78,0,11,0,186,0,134,0,60,0,0,0,179,0,0,0,154,0,100,0,105,0,191,0,49,0,0,0,0,0,50,0,248,0,171,0,189,0,110,0,111,0,130,0,0,0,93,0,53,0,0,0,99,0,49,0,130,0,250,0,84,0,62,0,57,0,16,0,35,0,28,0,111,0,248,0,63,0,0,0,38,0,0,0,31,0,211,0,0,0,0,0,247,0,110,0,12,0,106,0,127,0,91,0,104,0,88,0,0,0,0,0,12,0,202,0,118,0,230,0,135,0,235,0,130,0,92,0,93,0,245,0,92,0,0,0,0,0,174,0,0,0,228,0,157,0,63,0,0,0,247,0,146,0,217,0,117,0,71,0,161,0,95,0,150,0,71,0,219,0,245,0,0,0,65,0,79,0,155,0,189,0,220,0,7,0,210,0,146,0,21,0,0,0,0,0,0,0,1,0,254,0,159,0,122,0,231,0,85,0,125,0,55,0,8,0,249,0,50,0,211,0,56,0,215,0,153,0,82,0,75,0,159,0,1,0,213,0,0,0,213,0,0,0,32,0,238,0,0,0,98,0,190,0,0,0,132,0,136,0,113,0,112,0,212,0,227,0,130,0,0,0,72,0,202,0,186,0,0,0,69,0,143,0,0,0,0,0,248,0,70,0,92,0,2,0,0,0,57,0,17,0,143,0,193,0,234,0,23,0,22,0,47,0,155,0,103,0,107,0,11,0,7,0,208,0,0,0,58,0,2,0,111,0,159,0,0,0,28,0,182,0,84,0,198,0,178,0);
signal scenario_full  : scenario_type := (243,31,165,31,218,31,146,31,146,30,218,31,218,30,135,31,173,31,51,31,121,31,48,31,146,31,181,31,181,30,181,29,181,28,169,31,188,31,184,31,184,30,184,29,17,31,54,31,148,31,150,31,233,31,97,31,113,31,150,31,131,31,159,31,159,30,144,31,68,31,140,31,104,31,191,31,206,31,112,31,78,31,11,31,186,31,134,31,60,31,60,30,179,31,179,30,154,31,100,31,105,31,191,31,49,31,49,30,49,29,50,31,248,31,171,31,189,31,110,31,111,31,130,31,130,30,93,31,53,31,53,30,99,31,49,31,130,31,250,31,84,31,62,31,57,31,16,31,35,31,28,31,111,31,248,31,63,31,63,30,38,31,38,30,31,31,211,31,211,30,211,29,247,31,110,31,12,31,106,31,127,31,91,31,104,31,88,31,88,30,88,29,12,31,202,31,118,31,230,31,135,31,235,31,130,31,92,31,93,31,245,31,92,31,92,30,92,29,174,31,174,30,228,31,157,31,63,31,63,30,247,31,146,31,217,31,117,31,71,31,161,31,95,31,150,31,71,31,219,31,245,31,245,30,65,31,79,31,155,31,189,31,220,31,7,31,210,31,146,31,21,31,21,30,21,29,21,28,1,31,254,31,159,31,122,31,231,31,85,31,125,31,55,31,8,31,249,31,50,31,211,31,56,31,215,31,153,31,82,31,75,31,159,31,1,31,213,31,213,30,213,31,213,30,32,31,238,31,238,30,98,31,190,31,190,30,132,31,136,31,113,31,112,31,212,31,227,31,130,31,130,30,72,31,202,31,186,31,186,30,69,31,143,31,143,30,143,29,248,31,70,31,92,31,2,31,2,30,57,31,17,31,143,31,193,31,234,31,23,31,22,31,47,31,155,31,103,31,107,31,11,31,7,31,208,31,208,30,58,31,2,31,111,31,159,31,159,30,28,31,182,31,84,31,198,31,178,31);

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
