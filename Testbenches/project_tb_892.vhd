-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_892 is
end project_tb_892;

architecture project_tb_arch_892 of project_tb_892 is
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

constant SCENARIO_LENGTH : integer := 221;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (199,0,0,0,40,0,0,0,169,0,17,0,128,0,203,0,48,0,233,0,134,0,252,0,96,0,212,0,78,0,47,0,159,0,229,0,234,0,220,0,63,0,205,0,130,0,126,0,79,0,0,0,152,0,120,0,230,0,44,0,63,0,18,0,0,0,73,0,141,0,118,0,0,0,97,0,139,0,138,0,0,0,46,0,62,0,69,0,115,0,226,0,0,0,240,0,8,0,124,0,228,0,23,0,178,0,249,0,227,0,48,0,212,0,1,0,181,0,1,0,11,0,236,0,120,0,72,0,214,0,27,0,110,0,20,0,33,0,40,0,109,0,234,0,0,0,189,0,0,0,56,0,220,0,253,0,189,0,107,0,71,0,111,0,128,0,174,0,138,0,3,0,1,0,32,0,133,0,101,0,54,0,49,0,105,0,42,0,221,0,0,0,0,0,97,0,133,0,58,0,193,0,162,0,34,0,0,0,150,0,15,0,0,0,68,0,16,0,0,0,149,0,0,0,95,0,113,0,171,0,85,0,192,0,35,0,205,0,130,0,230,0,224,0,72,0,13,0,0,0,250,0,0,0,186,0,0,0,25,0,0,0,0,0,160,0,184,0,254,0,153,0,26,0,0,0,103,0,0,0,0,0,0,0,62,0,64,0,225,0,0,0,233,0,129,0,35,0,58,0,137,0,255,0,168,0,41,0,17,0,151,0,167,0,0,0,118,0,77,0,0,0,18,0,6,0,0,0,0,0,89,0,0,0,6,0,242,0,14,0,49,0,91,0,94,0,178,0,24,0,41,0,129,0,5,0,0,0,11,0,0,0,80,0,128,0,84,0,90,0,220,0,42,0,62,0,12,0,27,0,217,0,89,0,158,0,48,0,31,0,87,0,197,0,108,0,71,0,232,0,130,0,88,0,154,0,158,0,0,0,68,0,0,0,75,0,158,0,105,0,0,0,94,0,30,0,41,0,111,0,127,0,130,0,30,0,21,0,0,0,110,0);
signal scenario_full  : scenario_type := (199,31,199,30,40,31,40,30,169,31,17,31,128,31,203,31,48,31,233,31,134,31,252,31,96,31,212,31,78,31,47,31,159,31,229,31,234,31,220,31,63,31,205,31,130,31,126,31,79,31,79,30,152,31,120,31,230,31,44,31,63,31,18,31,18,30,73,31,141,31,118,31,118,30,97,31,139,31,138,31,138,30,46,31,62,31,69,31,115,31,226,31,226,30,240,31,8,31,124,31,228,31,23,31,178,31,249,31,227,31,48,31,212,31,1,31,181,31,1,31,11,31,236,31,120,31,72,31,214,31,27,31,110,31,20,31,33,31,40,31,109,31,234,31,234,30,189,31,189,30,56,31,220,31,253,31,189,31,107,31,71,31,111,31,128,31,174,31,138,31,3,31,1,31,32,31,133,31,101,31,54,31,49,31,105,31,42,31,221,31,221,30,221,29,97,31,133,31,58,31,193,31,162,31,34,31,34,30,150,31,15,31,15,30,68,31,16,31,16,30,149,31,149,30,95,31,113,31,171,31,85,31,192,31,35,31,205,31,130,31,230,31,224,31,72,31,13,31,13,30,250,31,250,30,186,31,186,30,25,31,25,30,25,29,160,31,184,31,254,31,153,31,26,31,26,30,103,31,103,30,103,29,103,28,62,31,64,31,225,31,225,30,233,31,129,31,35,31,58,31,137,31,255,31,168,31,41,31,17,31,151,31,167,31,167,30,118,31,77,31,77,30,18,31,6,31,6,30,6,29,89,31,89,30,6,31,242,31,14,31,49,31,91,31,94,31,178,31,24,31,41,31,129,31,5,31,5,30,11,31,11,30,80,31,128,31,84,31,90,31,220,31,42,31,62,31,12,31,27,31,217,31,89,31,158,31,48,31,31,31,87,31,197,31,108,31,71,31,232,31,130,31,88,31,154,31,158,31,158,30,68,31,68,30,75,31,158,31,105,31,105,30,94,31,30,31,41,31,111,31,127,31,130,31,30,31,21,31,21,30,110,31);

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
