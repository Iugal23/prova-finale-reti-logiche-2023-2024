-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_639 is
end project_tb_639;

architecture project_tb_arch_639 of project_tb_639 is
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

constant SCENARIO_LENGTH : integer := 548;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (40,0,246,0,0,0,0,0,90,0,137,0,123,0,5,0,211,0,198,0,69,0,163,0,65,0,44,0,152,0,116,0,51,0,223,0,0,0,238,0,196,0,0,0,92,0,152,0,119,0,3,0,247,0,0,0,30,0,0,0,50,0,0,0,0,0,104,0,100,0,43,0,0,0,170,0,241,0,0,0,0,0,78,0,101,0,12,0,0,0,179,0,128,0,242,0,160,0,0,0,122,0,0,0,0,0,0,0,0,0,67,0,219,0,223,0,0,0,208,0,0,0,0,0,0,0,0,0,239,0,5,0,51,0,0,0,2,0,233,0,13,0,239,0,0,0,232,0,255,0,38,0,149,0,72,0,146,0,39,0,68,0,177,0,32,0,0,0,0,0,191,0,3,0,0,0,28,0,52,0,63,0,58,0,109,0,231,0,221,0,211,0,102,0,174,0,220,0,7,0,56,0,230,0,27,0,0,0,13,0,249,0,0,0,204,0,11,0,0,0,88,0,142,0,151,0,0,0,230,0,0,0,188,0,0,0,20,0,134,0,168,0,52,0,145,0,147,0,159,0,206,0,209,0,162,0,83,0,192,0,0,0,221,0,248,0,106,0,241,0,0,0,225,0,161,0,206,0,38,0,247,0,69,0,39,0,0,0,215,0,221,0,188,0,116,0,0,0,122,0,124,0,0,0,170,0,85,0,0,0,240,0,120,0,65,0,0,0,111,0,13,0,55,0,0,0,237,0,82,0,193,0,135,0,131,0,0,0,0,0,148,0,194,0,144,0,65,0,167,0,255,0,0,0,214,0,166,0,178,0,210,0,0,0,86,0,198,0,1,0,175,0,22,0,137,0,118,0,242,0,0,0,0,0,99,0,4,0,156,0,0,0,53,0,141,0,38,0,0,0,168,0,70,0,247,0,28,0,183,0,233,0,106,0,70,0,4,0,234,0,191,0,127,0,0,0,197,0,118,0,0,0,251,0,184,0,149,0,211,0,224,0,85,0,44,0,47,0,218,0,158,0,107,0,119,0,34,0,4,0,43,0,254,0,0,0,0,0,151,0,104,0,104,0,0,0,0,0,115,0,85,0,0,0,0,0,54,0,189,0,0,0,136,0,12,0,241,0,189,0,219,0,241,0,121,0,70,0,217,0,155,0,0,0,62,0,143,0,0,0,4,0,132,0,152,0,223,0,0,0,51,0,12,0,178,0,9,0,163,0,39,0,144,0,0,0,33,0,215,0,63,0,122,0,128,0,163,0,0,0,0,0,43,0,6,0,131,0,92,0,39,0,187,0,112,0,34,0,131,0,46,0,0,0,0,0,193,0,44,0,120,0,178,0,0,0,0,0,160,0,82,0,193,0,196,0,141,0,0,0,136,0,81,0,2,0,124,0,10,0,52,0,11,0,0,0,34,0,193,0,126,0,175,0,0,0,0,0,143,0,6,0,90,0,41,0,0,0,164,0,63,0,156,0,240,0,157,0,0,0,249,0,159,0,0,0,36,0,16,0,0,0,114,0,85,0,244,0,84,0,216,0,130,0,118,0,153,0,245,0,0,0,26,0,188,0,153,0,0,0,154,0,197,0,154,0,83,0,232,0,107,0,77,0,246,0,108,0,176,0,126,0,0,0,0,0,213,0,22,0,96,0,76,0,111,0,179,0,55,0,138,0,0,0,1,0,0,0,0,0,27,0,145,0,234,0,67,0,139,0,119,0,0,0,15,0,144,0,80,0,106,0,112,0,0,0,0,0,0,0,157,0,202,0,30,0,214,0,0,0,198,0,0,0,147,0,120,0,23,0,0,0,168,0,47,0,228,0,106,0,39,0,10,0,72,0,216,0,212,0,209,0,63,0,50,0,224,0,49,0,32,0,211,0,69,0,120,0,0,0,186,0,224,0,5,0,34,0,143,0,0,0,0,0,0,0,0,0,0,0,37,0,17,0,107,0,199,0,0,0,33,0,0,0,238,0,206,0,83,0,1,0,182,0,254,0,140,0,84,0,111,0,106,0,0,0,52,0,99,0,120,0,88,0,0,0,145,0,0,0,236,0,173,0,19,0,69,0,77,0,2,0,0,0,121,0,215,0,73,0,80,0,145,0,117,0,58,0,0,0,229,0,29,0,217,0,91,0,0,0,0,0,0,0,224,0,251,0,240,0,7,0,99,0,213,0,180,0,0,0,153,0,195,0,32,0,242,0,191,0,214,0,36,0,129,0,188,0,174,0,159,0,7,0,0,0,137,0,0,0,0,0,220,0,0,0,132,0,35,0,0,0,184,0,5,0,180,0,0,0,182,0,0,0,167,0,118,0,140,0,62,0,126,0,146,0,0,0,227,0,97,0,13,0,232,0,62,0,95,0,143,0,134,0,145,0,246,0,38,0,186,0,46,0,66,0,90,0,248,0,16,0,46,0,168,0,199,0,231,0,0,0,0,0,78,0,12,0,15,0,218,0,0,0,0,0);
signal scenario_full  : scenario_type := (40,31,246,31,246,30,246,29,90,31,137,31,123,31,5,31,211,31,198,31,69,31,163,31,65,31,44,31,152,31,116,31,51,31,223,31,223,30,238,31,196,31,196,30,92,31,152,31,119,31,3,31,247,31,247,30,30,31,30,30,50,31,50,30,50,29,104,31,100,31,43,31,43,30,170,31,241,31,241,30,241,29,78,31,101,31,12,31,12,30,179,31,128,31,242,31,160,31,160,30,122,31,122,30,122,29,122,28,122,27,67,31,219,31,223,31,223,30,208,31,208,30,208,29,208,28,208,27,239,31,5,31,51,31,51,30,2,31,233,31,13,31,239,31,239,30,232,31,255,31,38,31,149,31,72,31,146,31,39,31,68,31,177,31,32,31,32,30,32,29,191,31,3,31,3,30,28,31,52,31,63,31,58,31,109,31,231,31,221,31,211,31,102,31,174,31,220,31,7,31,56,31,230,31,27,31,27,30,13,31,249,31,249,30,204,31,11,31,11,30,88,31,142,31,151,31,151,30,230,31,230,30,188,31,188,30,20,31,134,31,168,31,52,31,145,31,147,31,159,31,206,31,209,31,162,31,83,31,192,31,192,30,221,31,248,31,106,31,241,31,241,30,225,31,161,31,206,31,38,31,247,31,69,31,39,31,39,30,215,31,221,31,188,31,116,31,116,30,122,31,124,31,124,30,170,31,85,31,85,30,240,31,120,31,65,31,65,30,111,31,13,31,55,31,55,30,237,31,82,31,193,31,135,31,131,31,131,30,131,29,148,31,194,31,144,31,65,31,167,31,255,31,255,30,214,31,166,31,178,31,210,31,210,30,86,31,198,31,1,31,175,31,22,31,137,31,118,31,242,31,242,30,242,29,99,31,4,31,156,31,156,30,53,31,141,31,38,31,38,30,168,31,70,31,247,31,28,31,183,31,233,31,106,31,70,31,4,31,234,31,191,31,127,31,127,30,197,31,118,31,118,30,251,31,184,31,149,31,211,31,224,31,85,31,44,31,47,31,218,31,158,31,107,31,119,31,34,31,4,31,43,31,254,31,254,30,254,29,151,31,104,31,104,31,104,30,104,29,115,31,85,31,85,30,85,29,54,31,189,31,189,30,136,31,12,31,241,31,189,31,219,31,241,31,121,31,70,31,217,31,155,31,155,30,62,31,143,31,143,30,4,31,132,31,152,31,223,31,223,30,51,31,12,31,178,31,9,31,163,31,39,31,144,31,144,30,33,31,215,31,63,31,122,31,128,31,163,31,163,30,163,29,43,31,6,31,131,31,92,31,39,31,187,31,112,31,34,31,131,31,46,31,46,30,46,29,193,31,44,31,120,31,178,31,178,30,178,29,160,31,82,31,193,31,196,31,141,31,141,30,136,31,81,31,2,31,124,31,10,31,52,31,11,31,11,30,34,31,193,31,126,31,175,31,175,30,175,29,143,31,6,31,90,31,41,31,41,30,164,31,63,31,156,31,240,31,157,31,157,30,249,31,159,31,159,30,36,31,16,31,16,30,114,31,85,31,244,31,84,31,216,31,130,31,118,31,153,31,245,31,245,30,26,31,188,31,153,31,153,30,154,31,197,31,154,31,83,31,232,31,107,31,77,31,246,31,108,31,176,31,126,31,126,30,126,29,213,31,22,31,96,31,76,31,111,31,179,31,55,31,138,31,138,30,1,31,1,30,1,29,27,31,145,31,234,31,67,31,139,31,119,31,119,30,15,31,144,31,80,31,106,31,112,31,112,30,112,29,112,28,157,31,202,31,30,31,214,31,214,30,198,31,198,30,147,31,120,31,23,31,23,30,168,31,47,31,228,31,106,31,39,31,10,31,72,31,216,31,212,31,209,31,63,31,50,31,224,31,49,31,32,31,211,31,69,31,120,31,120,30,186,31,224,31,5,31,34,31,143,31,143,30,143,29,143,28,143,27,143,26,37,31,17,31,107,31,199,31,199,30,33,31,33,30,238,31,206,31,83,31,1,31,182,31,254,31,140,31,84,31,111,31,106,31,106,30,52,31,99,31,120,31,88,31,88,30,145,31,145,30,236,31,173,31,19,31,69,31,77,31,2,31,2,30,121,31,215,31,73,31,80,31,145,31,117,31,58,31,58,30,229,31,29,31,217,31,91,31,91,30,91,29,91,28,224,31,251,31,240,31,7,31,99,31,213,31,180,31,180,30,153,31,195,31,32,31,242,31,191,31,214,31,36,31,129,31,188,31,174,31,159,31,7,31,7,30,137,31,137,30,137,29,220,31,220,30,132,31,35,31,35,30,184,31,5,31,180,31,180,30,182,31,182,30,167,31,118,31,140,31,62,31,126,31,146,31,146,30,227,31,97,31,13,31,232,31,62,31,95,31,143,31,134,31,145,31,246,31,38,31,186,31,46,31,66,31,90,31,248,31,16,31,46,31,168,31,199,31,231,31,231,30,231,29,78,31,12,31,15,31,218,31,218,30,218,29);

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
