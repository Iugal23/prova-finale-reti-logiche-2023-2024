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

constant SCENARIO_LENGTH : integer := 210;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (176,0,23,0,249,0,38,0,0,0,117,0,51,0,28,0,83,0,181,0,154,0,163,0,104,0,232,0,60,0,0,0,54,0,36,0,0,0,79,0,109,0,231,0,157,0,149,0,235,0,0,0,50,0,16,0,0,0,0,0,58,0,0,0,185,0,157,0,0,0,99,0,20,0,74,0,103,0,0,0,50,0,134,0,214,0,209,0,19,0,101,0,183,0,0,0,31,0,216,0,223,0,220,0,0,0,193,0,0,0,206,0,0,0,211,0,210,0,247,0,66,0,106,0,237,0,90,0,93,0,145,0,0,0,0,0,157,0,149,0,208,0,144,0,195,0,32,0,196,0,0,0,0,0,130,0,107,0,67,0,79,0,211,0,33,0,43,0,115,0,119,0,0,0,249,0,7,0,0,0,65,0,22,0,25,0,143,0,181,0,242,0,0,0,6,0,0,0,34,0,160,0,164,0,0,0,176,0,162,0,0,0,181,0,18,0,15,0,26,0,108,0,156,0,87,0,9,0,46,0,0,0,232,0,225,0,54,0,106,0,51,0,170,0,106,0,0,0,153,0,0,0,162,0,79,0,22,0,114,0,254,0,174,0,203,0,252,0,141,0,121,0,0,0,0,0,123,0,242,0,0,0,47,0,144,0,0,0,12,0,239,0,74,0,131,0,34,0,182,0,44,0,189,0,0,0,184,0,0,0,20,0,0,0,0,0,12,0,135,0,197,0,191,0,83,0,0,0,20,0,20,0,166,0,153,0,0,0,246,0,150,0,42,0,0,0,191,0,0,0,125,0,210,0,214,0,0,0,135,0,54,0,107,0,0,0,133,0,160,0,82,0,219,0,114,0,2,0,0,0,26,0,92,0,0,0,53,0,191,0,0,0,72,0,0,0,182,0,150,0,88,0,158,0,0,0,25,0,184,0,183,0,147,0,0,0,208,0,0,0);
signal scenario_full  : scenario_type := (176,31,23,31,249,31,38,31,38,30,117,31,51,31,28,31,83,31,181,31,154,31,163,31,104,31,232,31,60,31,60,30,54,31,36,31,36,30,79,31,109,31,231,31,157,31,149,31,235,31,235,30,50,31,16,31,16,30,16,29,58,31,58,30,185,31,157,31,157,30,99,31,20,31,74,31,103,31,103,30,50,31,134,31,214,31,209,31,19,31,101,31,183,31,183,30,31,31,216,31,223,31,220,31,220,30,193,31,193,30,206,31,206,30,211,31,210,31,247,31,66,31,106,31,237,31,90,31,93,31,145,31,145,30,145,29,157,31,149,31,208,31,144,31,195,31,32,31,196,31,196,30,196,29,130,31,107,31,67,31,79,31,211,31,33,31,43,31,115,31,119,31,119,30,249,31,7,31,7,30,65,31,22,31,25,31,143,31,181,31,242,31,242,30,6,31,6,30,34,31,160,31,164,31,164,30,176,31,162,31,162,30,181,31,18,31,15,31,26,31,108,31,156,31,87,31,9,31,46,31,46,30,232,31,225,31,54,31,106,31,51,31,170,31,106,31,106,30,153,31,153,30,162,31,79,31,22,31,114,31,254,31,174,31,203,31,252,31,141,31,121,31,121,30,121,29,123,31,242,31,242,30,47,31,144,31,144,30,12,31,239,31,74,31,131,31,34,31,182,31,44,31,189,31,189,30,184,31,184,30,20,31,20,30,20,29,12,31,135,31,197,31,191,31,83,31,83,30,20,31,20,31,166,31,153,31,153,30,246,31,150,31,42,31,42,30,191,31,191,30,125,31,210,31,214,31,214,30,135,31,54,31,107,31,107,30,133,31,160,31,82,31,219,31,114,31,2,31,2,30,26,31,92,31,92,30,53,31,191,31,191,30,72,31,72,30,182,31,150,31,88,31,158,31,158,30,25,31,184,31,183,31,147,31,147,30,208,31,208,30);

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
