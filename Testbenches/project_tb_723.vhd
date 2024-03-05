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

constant SCENARIO_LENGTH : integer := 316;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (136,0,241,0,103,0,96,0,94,0,96,0,237,0,0,0,82,0,201,0,18,0,180,0,7,0,0,0,142,0,0,0,87,0,79,0,240,0,247,0,61,0,0,0,152,0,187,0,194,0,6,0,105,0,119,0,0,0,24,0,99,0,15,0,120,0,185,0,111,0,0,0,237,0,213,0,50,0,3,0,120,0,182,0,51,0,92,0,0,0,147,0,118,0,249,0,147,0,189,0,41,0,180,0,115,0,238,0,11,0,0,0,98,0,165,0,0,0,235,0,7,0,16,0,145,0,149,0,0,0,46,0,24,0,54,0,0,0,0,0,0,0,43,0,0,0,242,0,0,0,19,0,72,0,240,0,216,0,62,0,158,0,19,0,233,0,234,0,159,0,0,0,23,0,248,0,128,0,91,0,135,0,0,0,236,0,202,0,4,0,170,0,0,0,0,0,0,0,58,0,48,0,58,0,146,0,125,0,135,0,124,0,79,0,133,0,5,0,60,0,0,0,0,0,56,0,0,0,11,0,0,0,135,0,79,0,235,0,108,0,56,0,167,0,29,0,12,0,0,0,109,0,152,0,87,0,0,0,0,0,27,0,188,0,6,0,198,0,11,0,53,0,199,0,0,0,60,0,250,0,0,0,236,0,69,0,0,0,0,0,13,0,44,0,83,0,0,0,37,0,0,0,235,0,94,0,0,0,13,0,44,0,3,0,248,0,216,0,83,0,212,0,73,0,122,0,88,0,104,0,130,0,110,0,64,0,69,0,186,0,114,0,46,0,0,0,163,0,228,0,75,0,179,0,138,0,142,0,225,0,138,0,3,0,98,0,242,0,171,0,210,0,60,0,47,0,0,0,73,0,41,0,239,0,135,0,1,0,182,0,255,0,0,0,116,0,141,0,0,0,201,0,181,0,56,0,13,0,110,0,222,0,0,0,1,0,174,0,0,0,0,0,99,0,114,0,94,0,185,0,0,0,0,0,114,0,225,0,0,0,85,0,148,0,70,0,0,0,181,0,0,0,23,0,24,0,208,0,203,0,238,0,187,0,19,0,190,0,150,0,96,0,70,0,99,0,76,0,179,0,0,0,89,0,13,0,104,0,96,0,0,0,188,0,36,0,219,0,0,0,145,0,220,0,0,0,90,0,84,0,109,0,45,0,141,0,0,0,233,0,0,0,126,0,206,0,0,0,94,0,240,0,100,0,194,0,225,0,153,0,0,0,178,0,241,0,14,0,30,0,200,0,173,0,0,0,198,0,150,0,226,0,0,0,34,0,235,0,168,0,0,0,119,0,76,0,0,0,249,0,0,0,179,0,0,0,0,0,115,0,175,0,95,0,110,0,0,0,201,0,0,0,121,0,0,0,13,0,245,0,0,0,6,0,0,0,7,0,204,0,24,0,0,0,208,0,0,0,0,0,100,0);
signal scenario_full  : scenario_type := (136,31,241,31,103,31,96,31,94,31,96,31,237,31,237,30,82,31,201,31,18,31,180,31,7,31,7,30,142,31,142,30,87,31,79,31,240,31,247,31,61,31,61,30,152,31,187,31,194,31,6,31,105,31,119,31,119,30,24,31,99,31,15,31,120,31,185,31,111,31,111,30,237,31,213,31,50,31,3,31,120,31,182,31,51,31,92,31,92,30,147,31,118,31,249,31,147,31,189,31,41,31,180,31,115,31,238,31,11,31,11,30,98,31,165,31,165,30,235,31,7,31,16,31,145,31,149,31,149,30,46,31,24,31,54,31,54,30,54,29,54,28,43,31,43,30,242,31,242,30,19,31,72,31,240,31,216,31,62,31,158,31,19,31,233,31,234,31,159,31,159,30,23,31,248,31,128,31,91,31,135,31,135,30,236,31,202,31,4,31,170,31,170,30,170,29,170,28,58,31,48,31,58,31,146,31,125,31,135,31,124,31,79,31,133,31,5,31,60,31,60,30,60,29,56,31,56,30,11,31,11,30,135,31,79,31,235,31,108,31,56,31,167,31,29,31,12,31,12,30,109,31,152,31,87,31,87,30,87,29,27,31,188,31,6,31,198,31,11,31,53,31,199,31,199,30,60,31,250,31,250,30,236,31,69,31,69,30,69,29,13,31,44,31,83,31,83,30,37,31,37,30,235,31,94,31,94,30,13,31,44,31,3,31,248,31,216,31,83,31,212,31,73,31,122,31,88,31,104,31,130,31,110,31,64,31,69,31,186,31,114,31,46,31,46,30,163,31,228,31,75,31,179,31,138,31,142,31,225,31,138,31,3,31,98,31,242,31,171,31,210,31,60,31,47,31,47,30,73,31,41,31,239,31,135,31,1,31,182,31,255,31,255,30,116,31,141,31,141,30,201,31,181,31,56,31,13,31,110,31,222,31,222,30,1,31,174,31,174,30,174,29,99,31,114,31,94,31,185,31,185,30,185,29,114,31,225,31,225,30,85,31,148,31,70,31,70,30,181,31,181,30,23,31,24,31,208,31,203,31,238,31,187,31,19,31,190,31,150,31,96,31,70,31,99,31,76,31,179,31,179,30,89,31,13,31,104,31,96,31,96,30,188,31,36,31,219,31,219,30,145,31,220,31,220,30,90,31,84,31,109,31,45,31,141,31,141,30,233,31,233,30,126,31,206,31,206,30,94,31,240,31,100,31,194,31,225,31,153,31,153,30,178,31,241,31,14,31,30,31,200,31,173,31,173,30,198,31,150,31,226,31,226,30,34,31,235,31,168,31,168,30,119,31,76,31,76,30,249,31,249,30,179,31,179,30,179,29,115,31,175,31,95,31,110,31,110,30,201,31,201,30,121,31,121,30,13,31,245,31,245,30,6,31,6,30,7,31,204,31,24,31,24,30,208,31,208,30,208,29,100,31);

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
