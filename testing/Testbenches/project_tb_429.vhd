-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_429 is
end project_tb_429;

architecture project_tb_arch_429 of project_tb_429 is
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

constant SCENARIO_LENGTH : integer := 392;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (149,0,101,0,60,0,0,0,195,0,225,0,150,0,54,0,169,0,165,0,252,0,0,0,251,0,130,0,0,0,27,0,95,0,226,0,150,0,80,0,250,0,28,0,0,0,0,0,236,0,29,0,43,0,185,0,0,0,0,0,254,0,0,0,62,0,104,0,0,0,143,0,0,0,53,0,106,0,108,0,0,0,242,0,35,0,0,0,0,0,110,0,189,0,131,0,0,0,246,0,101,0,0,0,126,0,12,0,245,0,0,0,0,0,39,0,84,0,210,0,202,0,1,0,149,0,6,0,134,0,0,0,184,0,157,0,43,0,38,0,0,0,0,0,194,0,10,0,93,0,111,0,140,0,160,0,225,0,151,0,209,0,235,0,3,0,177,0,237,0,221,0,0,0,197,0,0,0,0,0,199,0,250,0,29,0,0,0,247,0,174,0,152,0,0,0,178,0,176,0,235,0,134,0,0,0,137,0,93,0,72,0,16,0,93,0,161,0,44,0,139,0,246,0,63,0,0,0,186,0,56,0,214,0,0,0,63,0,0,0,67,0,236,0,0,0,0,0,0,0,242,0,11,0,0,0,184,0,104,0,162,0,113,0,25,0,0,0,212,0,250,0,100,0,104,0,94,0,123,0,0,0,45,0,77,0,10,0,13,0,233,0,23,0,0,0,233,0,58,0,175,0,194,0,238,0,149,0,0,0,0,0,0,0,155,0,44,0,170,0,57,0,0,0,223,0,49,0,87,0,0,0,109,0,106,0,195,0,157,0,0,0,0,0,12,0,65,0,142,0,19,0,79,0,22,0,146,0,0,0,53,0,0,0,19,0,17,0,187,0,19,0,23,0,154,0,113,0,216,0,0,0,0,0,93,0,236,0,4,0,83,0,217,0,162,0,150,0,159,0,120,0,0,0,238,0,168,0,53,0,0,0,44,0,104,0,250,0,92,0,16,0,54,0,137,0,42,0,150,0,135,0,105,0,201,0,26,0,115,0,184,0,232,0,61,0,165,0,0,0,162,0,10,0,0,0,58,0,91,0,179,0,85,0,164,0,0,0,215,0,178,0,58,0,228,0,0,0,131,0,2,0,107,0,159,0,53,0,92,0,192,0,172,0,201,0,25,0,37,0,0,0,113,0,65,0,0,0,186,0,58,0,137,0,5,0,14,0,230,0,0,0,119,0,225,0,99,0,3,0,121,0,138,0,166,0,0,0,172,0,162,0,118,0,0,0,180,0,201,0,149,0,0,0,0,0,0,0,20,0,15,0,88,0,0,0,119,0,84,0,186,0,49,0,0,0,32,0,45,0,97,0,41,0,97,0,183,0,79,0,249,0,180,0,78,0,11,0,143,0,0,0,218,0,90,0,114,0,164,0,213,0,130,0,166,0,69,0,0,0,209,0,12,0,75,0,0,0,0,0,0,0,140,0,237,0,130,0,224,0,71,0,151,0,206,0,242,0,38,0,20,0,157,0,0,0,57,0,108,0,173,0,132,0,218,0,54,0,14,0,245,0,212,0,152,0,112,0,155,0,71,0,33,0,12,0,201,0,0,0,192,0,80,0,249,0,130,0,46,0,0,0,44,0,205,0,45,0,0,0,241,0,125,0,0,0,0,0,152,0,225,0,55,0,239,0,31,0,185,0,0,0,176,0,55,0,171,0,0,0,255,0,17,0,0,0,50,0,0,0,14,0,134,0,0,0,0,0,249,0,250,0,251,0,0,0,125,0,214,0,178,0,159,0,81,0,0,0,235,0,90,0,0,0);
signal scenario_full  : scenario_type := (149,31,101,31,60,31,60,30,195,31,225,31,150,31,54,31,169,31,165,31,252,31,252,30,251,31,130,31,130,30,27,31,95,31,226,31,150,31,80,31,250,31,28,31,28,30,28,29,236,31,29,31,43,31,185,31,185,30,185,29,254,31,254,30,62,31,104,31,104,30,143,31,143,30,53,31,106,31,108,31,108,30,242,31,35,31,35,30,35,29,110,31,189,31,131,31,131,30,246,31,101,31,101,30,126,31,12,31,245,31,245,30,245,29,39,31,84,31,210,31,202,31,1,31,149,31,6,31,134,31,134,30,184,31,157,31,43,31,38,31,38,30,38,29,194,31,10,31,93,31,111,31,140,31,160,31,225,31,151,31,209,31,235,31,3,31,177,31,237,31,221,31,221,30,197,31,197,30,197,29,199,31,250,31,29,31,29,30,247,31,174,31,152,31,152,30,178,31,176,31,235,31,134,31,134,30,137,31,93,31,72,31,16,31,93,31,161,31,44,31,139,31,246,31,63,31,63,30,186,31,56,31,214,31,214,30,63,31,63,30,67,31,236,31,236,30,236,29,236,28,242,31,11,31,11,30,184,31,104,31,162,31,113,31,25,31,25,30,212,31,250,31,100,31,104,31,94,31,123,31,123,30,45,31,77,31,10,31,13,31,233,31,23,31,23,30,233,31,58,31,175,31,194,31,238,31,149,31,149,30,149,29,149,28,155,31,44,31,170,31,57,31,57,30,223,31,49,31,87,31,87,30,109,31,106,31,195,31,157,31,157,30,157,29,12,31,65,31,142,31,19,31,79,31,22,31,146,31,146,30,53,31,53,30,19,31,17,31,187,31,19,31,23,31,154,31,113,31,216,31,216,30,216,29,93,31,236,31,4,31,83,31,217,31,162,31,150,31,159,31,120,31,120,30,238,31,168,31,53,31,53,30,44,31,104,31,250,31,92,31,16,31,54,31,137,31,42,31,150,31,135,31,105,31,201,31,26,31,115,31,184,31,232,31,61,31,165,31,165,30,162,31,10,31,10,30,58,31,91,31,179,31,85,31,164,31,164,30,215,31,178,31,58,31,228,31,228,30,131,31,2,31,107,31,159,31,53,31,92,31,192,31,172,31,201,31,25,31,37,31,37,30,113,31,65,31,65,30,186,31,58,31,137,31,5,31,14,31,230,31,230,30,119,31,225,31,99,31,3,31,121,31,138,31,166,31,166,30,172,31,162,31,118,31,118,30,180,31,201,31,149,31,149,30,149,29,149,28,20,31,15,31,88,31,88,30,119,31,84,31,186,31,49,31,49,30,32,31,45,31,97,31,41,31,97,31,183,31,79,31,249,31,180,31,78,31,11,31,143,31,143,30,218,31,90,31,114,31,164,31,213,31,130,31,166,31,69,31,69,30,209,31,12,31,75,31,75,30,75,29,75,28,140,31,237,31,130,31,224,31,71,31,151,31,206,31,242,31,38,31,20,31,157,31,157,30,57,31,108,31,173,31,132,31,218,31,54,31,14,31,245,31,212,31,152,31,112,31,155,31,71,31,33,31,12,31,201,31,201,30,192,31,80,31,249,31,130,31,46,31,46,30,44,31,205,31,45,31,45,30,241,31,125,31,125,30,125,29,152,31,225,31,55,31,239,31,31,31,185,31,185,30,176,31,55,31,171,31,171,30,255,31,17,31,17,30,50,31,50,30,14,31,134,31,134,30,134,29,249,31,250,31,251,31,251,30,125,31,214,31,178,31,159,31,81,31,81,30,235,31,90,31,90,30);

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
