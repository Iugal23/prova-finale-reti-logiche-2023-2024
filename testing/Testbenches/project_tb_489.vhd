-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_489 is
end project_tb_489;

architecture project_tb_arch_489 of project_tb_489 is
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

constant SCENARIO_LENGTH : integer := 479;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (191,0,31,0,0,0,0,0,199,0,0,0,226,0,0,0,0,0,2,0,0,0,0,0,27,0,149,0,72,0,199,0,254,0,0,0,0,0,118,0,193,0,17,0,168,0,43,0,0,0,185,0,12,0,0,0,76,0,3,0,82,0,76,0,119,0,125,0,199,0,189,0,68,0,8,0,217,0,79,0,201,0,255,0,139,0,0,0,217,0,229,0,233,0,120,0,231,0,60,0,0,0,43,0,168,0,42,0,101,0,0,0,87,0,140,0,0,0,0,0,150,0,92,0,21,0,0,0,121,0,86,0,209,0,10,0,0,0,182,0,48,0,171,0,15,0,84,0,230,0,118,0,0,0,150,0,174,0,104,0,0,0,210,0,25,0,92,0,0,0,129,0,186,0,133,0,0,0,200,0,178,0,3,0,0,0,147,0,0,0,221,0,174,0,45,0,197,0,1,0,189,0,0,0,0,0,246,0,0,0,14,0,0,0,0,0,0,0,15,0,162,0,0,0,175,0,82,0,249,0,0,0,77,0,0,0,202,0,100,0,168,0,241,0,131,0,47,0,188,0,109,0,61,0,0,0,223,0,0,0,199,0,234,0,0,0,40,0,160,0,75,0,254,0,146,0,85,0,0,0,147,0,32,0,67,0,0,0,0,0,50,0,148,0,180,0,36,0,124,0,0,0,168,0,177,0,0,0,39,0,241,0,27,0,98,0,56,0,11,0,221,0,0,0,200,0,140,0,148,0,210,0,168,0,197,0,139,0,121,0,250,0,210,0,148,0,0,0,86,0,153,0,96,0,93,0,92,0,84,0,10,0,91,0,34,0,0,0,0,0,189,0,140,0,218,0,217,0,70,0,10,0,0,0,0,0,143,0,178,0,178,0,0,0,218,0,1,0,181,0,215,0,104,0,101,0,252,0,98,0,243,0,157,0,0,0,189,0,33,0,0,0,19,0,116,0,138,0,0,0,0,0,105,0,115,0,0,0,62,0,142,0,0,0,42,0,125,0,55,0,42,0,129,0,0,0,0,0,179,0,240,0,162,0,75,0,237,0,32,0,19,0,87,0,233,0,0,0,0,0,0,0,85,0,157,0,0,0,133,0,188,0,140,0,36,0,0,0,0,0,1,0,103,0,0,0,30,0,141,0,95,0,143,0,0,0,169,0,79,0,254,0,79,0,0,0,181,0,100,0,211,0,199,0,37,0,80,0,183,0,0,0,40,0,75,0,213,0,246,0,0,0,0,0,194,0,106,0,221,0,111,0,69,0,115,0,17,0,155,0,78,0,47,0,0,0,250,0,73,0,222,0,16,0,138,0,95,0,129,0,13,0,69,0,172,0,0,0,218,0,92,0,39,0,129,0,0,0,12,0,136,0,156,0,90,0,47,0,42,0,96,0,0,0,55,0,156,0,0,0,115,0,3,0,161,0,145,0,0,0,196,0,103,0,194,0,230,0,167,0,0,0,94,0,25,0,0,0,0,0,108,0,237,0,0,0,0,0,10,0,0,0,105,0,119,0,0,0,0,0,171,0,0,0,65,0,91,0,11,0,83,0,21,0,238,0,244,0,0,0,147,0,97,0,189,0,202,0,28,0,0,0,0,0,0,0,0,0,78,0,11,0,173,0,73,0,240,0,104,0,107,0,180,0,182,0,0,0,228,0,119,0,55,0,178,0,29,0,178,0,59,0,173,0,87,0,0,0,109,0,111,0,201,0,0,0,139,0,190,0,220,0,138,0,0,0,0,0,56,0,135,0,6,0,13,0,194,0,169,0,115,0,0,0,58,0,237,0,234,0,0,0,193,0,211,0,0,0,97,0,0,0,0,0,74,0,38,0,199,0,0,0,0,0,122,0,170,0,0,0,221,0,162,0,252,0,191,0,193,0,39,0,208,0,184,0,130,0,0,0,78,0,12,0,227,0,0,0,237,0,98,0,0,0,233,0,205,0,155,0,0,0,124,0,72,0,55,0,110,0,11,0,162,0,179,0,77,0,97,0,101,0,232,0,221,0,138,0,114,0,209,0,233,0,241,0,0,0,96,0,14,0,84,0,253,0,65,0,64,0,172,0,239,0,245,0,14,0,137,0,4,0,62,0,126,0,50,0,65,0,134,0,203,0,0,0,145,0,244,0,214,0,77,0,241,0,97,0);
signal scenario_full  : scenario_type := (191,31,31,31,31,30,31,29,199,31,199,30,226,31,226,30,226,29,2,31,2,30,2,29,27,31,149,31,72,31,199,31,254,31,254,30,254,29,118,31,193,31,17,31,168,31,43,31,43,30,185,31,12,31,12,30,76,31,3,31,82,31,76,31,119,31,125,31,199,31,189,31,68,31,8,31,217,31,79,31,201,31,255,31,139,31,139,30,217,31,229,31,233,31,120,31,231,31,60,31,60,30,43,31,168,31,42,31,101,31,101,30,87,31,140,31,140,30,140,29,150,31,92,31,21,31,21,30,121,31,86,31,209,31,10,31,10,30,182,31,48,31,171,31,15,31,84,31,230,31,118,31,118,30,150,31,174,31,104,31,104,30,210,31,25,31,92,31,92,30,129,31,186,31,133,31,133,30,200,31,178,31,3,31,3,30,147,31,147,30,221,31,174,31,45,31,197,31,1,31,189,31,189,30,189,29,246,31,246,30,14,31,14,30,14,29,14,28,15,31,162,31,162,30,175,31,82,31,249,31,249,30,77,31,77,30,202,31,100,31,168,31,241,31,131,31,47,31,188,31,109,31,61,31,61,30,223,31,223,30,199,31,234,31,234,30,40,31,160,31,75,31,254,31,146,31,85,31,85,30,147,31,32,31,67,31,67,30,67,29,50,31,148,31,180,31,36,31,124,31,124,30,168,31,177,31,177,30,39,31,241,31,27,31,98,31,56,31,11,31,221,31,221,30,200,31,140,31,148,31,210,31,168,31,197,31,139,31,121,31,250,31,210,31,148,31,148,30,86,31,153,31,96,31,93,31,92,31,84,31,10,31,91,31,34,31,34,30,34,29,189,31,140,31,218,31,217,31,70,31,10,31,10,30,10,29,143,31,178,31,178,31,178,30,218,31,1,31,181,31,215,31,104,31,101,31,252,31,98,31,243,31,157,31,157,30,189,31,33,31,33,30,19,31,116,31,138,31,138,30,138,29,105,31,115,31,115,30,62,31,142,31,142,30,42,31,125,31,55,31,42,31,129,31,129,30,129,29,179,31,240,31,162,31,75,31,237,31,32,31,19,31,87,31,233,31,233,30,233,29,233,28,85,31,157,31,157,30,133,31,188,31,140,31,36,31,36,30,36,29,1,31,103,31,103,30,30,31,141,31,95,31,143,31,143,30,169,31,79,31,254,31,79,31,79,30,181,31,100,31,211,31,199,31,37,31,80,31,183,31,183,30,40,31,75,31,213,31,246,31,246,30,246,29,194,31,106,31,221,31,111,31,69,31,115,31,17,31,155,31,78,31,47,31,47,30,250,31,73,31,222,31,16,31,138,31,95,31,129,31,13,31,69,31,172,31,172,30,218,31,92,31,39,31,129,31,129,30,12,31,136,31,156,31,90,31,47,31,42,31,96,31,96,30,55,31,156,31,156,30,115,31,3,31,161,31,145,31,145,30,196,31,103,31,194,31,230,31,167,31,167,30,94,31,25,31,25,30,25,29,108,31,237,31,237,30,237,29,10,31,10,30,105,31,119,31,119,30,119,29,171,31,171,30,65,31,91,31,11,31,83,31,21,31,238,31,244,31,244,30,147,31,97,31,189,31,202,31,28,31,28,30,28,29,28,28,28,27,78,31,11,31,173,31,73,31,240,31,104,31,107,31,180,31,182,31,182,30,228,31,119,31,55,31,178,31,29,31,178,31,59,31,173,31,87,31,87,30,109,31,111,31,201,31,201,30,139,31,190,31,220,31,138,31,138,30,138,29,56,31,135,31,6,31,13,31,194,31,169,31,115,31,115,30,58,31,237,31,234,31,234,30,193,31,211,31,211,30,97,31,97,30,97,29,74,31,38,31,199,31,199,30,199,29,122,31,170,31,170,30,221,31,162,31,252,31,191,31,193,31,39,31,208,31,184,31,130,31,130,30,78,31,12,31,227,31,227,30,237,31,98,31,98,30,233,31,205,31,155,31,155,30,124,31,72,31,55,31,110,31,11,31,162,31,179,31,77,31,97,31,101,31,232,31,221,31,138,31,114,31,209,31,233,31,241,31,241,30,96,31,14,31,84,31,253,31,65,31,64,31,172,31,239,31,245,31,14,31,137,31,4,31,62,31,126,31,50,31,65,31,134,31,203,31,203,30,145,31,244,31,214,31,77,31,241,31,97,31);

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
